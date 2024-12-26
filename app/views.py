from flask import Blueprint, render_template, request, jsonify,flash,redirect,url_for
from werkzeug.security import check_password_hash
from .database import Database
import pymysql
from datetime import datetime
import uuid
# 创建一个 Blueprint 对象
main_views = Blueprint('main', __name__)

@main_views.route('/')
def index():
    return render_template('index.html')

@main_views.route('/login', methods=['POST'])
def login():
    data = request.json
    customer_id = data.get('CustomerID')
    password = data.get('Password')

    if not customer_id or not password:
        return jsonify({"message": "Missing data"}), 400

    db = Database()
    conn = db.connect()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        cursor.execute("SELECT * FROM customers WHERE CustomerID = %s", (customer_id,))
        customer = cursor.fetchone()
        if customer and check_password_hash(customer['Password'], password):
            return jsonify({"message": "Login successful", "customer_id": customer_id})
        else:
            return jsonify({"message": "Invalid credentials"}), 401
    except Exception as e:
        return jsonify({"message": "Error logging in", "error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@main_views.route('/customer/info', methods=['GET'])
def get_customer_info():
    customer_id = request.args.get('customer_id')
    password = request.args.get('password')  # 获取URL参数中的密码

    if not customer_id or not password:  # 检查是否提供了customer_id和password
        return jsonify({"message": "Missing customer_id or password"}), 400

    db = Database()
    conn = db.connect()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        cursor.execute("SELECT * FROM customers WHERE CustomerID = %s", (customer_id,))
        customer = cursor.fetchone()
        if customer and check_password_hash(customer['Password'], password):  # 验证密码
            # 确保不返回密码信息
            customer.pop('Password', None)
            cursor.execute("SELECT * FROM viewcustomerorders WHERE CustomerID = %s", (customer_id,))
            orders = cursor.fetchall()
            return jsonify({"customer": customer, "orders": orders})
        else:
            return jsonify({"message": "Invalid customer_id or password"}), 401
    except Exception as e:
        return jsonify({"message": "Error retrieving customer info", "error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@main_views.route('/books', methods=['GET'])
def search_books():
    isbn = request.args.get('isbn')
    title = request.args.get('title')
    publisher = request.args.get('publisher')
    keywords = request.args.get('keywords')
    author = request.args.get('author')
    match_degree = request.args.get('match_degree')  # 可选参数

    db = Database()
    conn = db.connect()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    query = "SELECT * FROM books WHERE 1=1"
    conditions = []
    params = []

    if isbn:
        conditions.append("ISBN = %s")
        params.append(isbn)
    if title:
        conditions.append("Title LIKE %s")
        params.append(f"%{title}%")  # 模糊查询
    if publisher:
        conditions.append("PublisherID IN (SELECT PublisherID FROM publishers WHERE PublisherName = %s)")
        params.append(publisher)
    if keywords:
        conditions.append("Keywords LIKE %s")
        params.append(f"%{keywords}%")  # 模糊查询
    if author:
        conditions.append("AuthorName LIKE %s")  # 假设有一个作者表和关联
        params.append(f"%{author}%")  # 模糊查询

    if conditions:
        query += " AND " + " AND ".join(conditions)

    try:
        cursor.execute(query, tuple(params))
        books = cursor.fetchall()
        return jsonify(books)
    except Exception as e:
        return jsonify({"message": "Error searching books", "error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@main_views.route('/admin')
def admin():
    # 这里可以添加管理员登录验证逻辑
    return render_template('admin.html')  # 渲染管理员界面模板


@main_views.route('/admin/books', methods=['GET', 'POST'])
def manage_books():
    db = Database()
    conn = db.connect()
    cursor = conn.cursor(pymysql.cursors.DictCursor)
    
    if request.method == 'POST':
        # 获取表单数据
        title = request.form.get('title')
        authors = request.form.get('authors').split(',')  # 假设作者字段以逗号分隔
        publisher_id = request.form.get('publisher_id')
        price = request.form.get('price')
        keywords = request.form.get('keywords').split(',')  # 假设关键字字段以逗号分隔
        summary = request.form.get('summary')
        cover_image_file = request.files.get('cover_image')  # 获取文件对象
        stock_quantity = request.form.get('stock_quantity')
        suppliers = request.form.get('supplier').split(',')  # 假设供应商字段以逗号分隔
        
        # 数据验证
        if not all([title, price]):
            flash('标题和价格是必填字段。')
            return redirect(url_for('main.manage_books'))
        
        try:
            # 插入书籍信息到数据库（不包括ISBN，因为它是自增的）
            cursor.execute("INSERT INTO books (Title, PublisherID, Price, Keywords, Summary, StockQuantity) VALUES (%s, %s, %s, %s, %s, %s)", (title, publisher_id, price, ','.join(keywords), summary, stock_quantity))
            conn.commit()
            
            # 获取自增的ISBN
            last_inserted_isbn = cursor.lastrowid
            
            
            # 处理作者关系
            for author in authors:
                cursor.execute("INSERT INTO authors (AuthorName) VALUES (%s)", (author,))
                conn.commit()
                author_id = cursor.lastrowid
                cursor.execute("INSERT INTO book_authors (BookISBN, AuthorID) VALUES (%s, %s)", (last_inserted_isbn, author_id))
                conn.commit()
            
            # 处理供应商关系
            for supplier_name in suppliers:
                cursor.execute("SELECT SupplierID FROM suppliers WHERE SupplierName = %s", (supplier_name,))
                supplier_id = cursor.fetchone()
                if supplier_id:
                    cursor.execute("INSERT INTO book_suppliers (BookISBN, SupplierID) VALUES (%s, %s)", (last_inserted_isbn, supplier_id['SupplierID']))
                    conn.commit()
                else:
                    cursor.execute("INSERT INTO suppliers (SupplierName) VALUES (%s)", (supplier_name,))
                    conn.commit()
                    supplier_id = cursor.lastrowid
                    cursor.execute("INSERT INTO book_suppliers (BookISBN, SupplierID) VALUES (%s, %s)", (last_inserted_isbn, supplier_id))
                    conn.commit()
            
            flash('新书添加成功！')
        except pymysql.MySQLError as e:
            conn.rollback()
            flash('添加新书失败：' + str(e))
        finally:
            cursor.close()
            conn.close()
        return redirect(url_for('main.manage_books'))
    
    # 查询所有图书信息
    cursor.execute("SELECT * FROM books")
    books = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return render_template('admin_books.html', books=books)

@main_views.route('/admin/missingBook')
def missing_book():
    return render_template('missingBook.html')

@main_views.route('/api/missingbooks', methods=['POST'])
def register_missing_book():
    db = Database()
    data = request.json
    isbn = data.get('isbn')
    title = data.get('title')
    publisher = data.get('publisher')
    supplier = data.get('supplier')
    quantity = data.get('quantity')

    try:
        conn = db.connect()
        with conn.cursor() as cursor:
            query = """
                INSERT INTO missingbooks (ISBN, Title, PublisherID, SupplierID, Quantity, Register_Date)
                VALUES (%s, %s, %s, %s, %s, CURDATE())
            """
            cursor.execute(query, (isbn, title, publisher, supplier, quantity))
            conn.commit()
        return jsonify({"success": True, "message": "登记成功", "data": data})
    except Exception as e:
        return jsonify({"success": False, "message": "登记失败，请重试", "error": str(e)}), 500
    finally:
        conn.close()

@main_views.route('/admin/users', methods=['GET'])
def admin_customer():
    return render_template('admin_customers.html')

@main_views.route('/get_customer_info', methods=['GET'])
def customer_info():
    customer_id = request.args.get('customer_id')
    if not customer_id:
        return jsonify({"message": "Missing customer_id"}), 400

    db = Database()
    conn = db.connect()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        # 查询客户信息
        cursor.execute("SELECT * FROM customers WHERE CustomerID = %s", (customer_id,))
        customer = cursor.fetchone()
        if not customer:
            return jsonify({"message": "Customer not found"}), 404

        # 查询订单信息
        cursor.execute("SELECT * FROM orders WHERE CustomerID = %s", (customer_id,))
        orders = cursor.fetchall()

        # 返回客户信息和订单信息
        return jsonify({"customer": customer, "orders": orders})
    except Exception as e:
        # 捕获异常并返回详细的错误信息
        error_message = f"Error retrieving customer info: {str(e)}"
        return jsonify({"message": error_message}), 500
    finally:
        cursor.close()
        conn.close()

@main_views.route('/place_order_form', methods=['GET'])
def place_order_form():
    return render_template('order_form.html')

@main_views.route('/place_order', methods=['POST'])
def place_order():
    customer_id = request.form.get('customer_id')
    books = request.form.get('books').split(',')
    quantity = int(request.form.get('quantity'))
    shipping_address = request.form.get('shipping_address')

    # 这里应该添加逻辑来检查库存，创建订单，以及更新库存
    # 以下代码是一个简化的示例，实际应用中需要更复杂的逻辑

    order_date = datetime.now().strftime('%Y-%m-%d')
    total_amount = 1  # 假设这是一个计算总金额的函数

    # 插入订单信息到数据库，不包括自增的OrderID
    db = Database()
    conn = db.connect()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO orders (OrderDate, CustomerID, ShippingAddress, TotalAmount) VALUES (%s, %s, %s, %s)",
                   (order_date, customer_id, shipping_address, total_amount))
    conn.commit()
    order_id = cursor.lastrowid  # 获取数据库生成的自增ID
    cursor.close()
    conn.close()

    # 重定向到订单确认页面
    return render_template('order_confirmation.html', 
                           order_id=order_id, 
                           order_date=order_date, 
                           customer_id=customer_id, 
                           total_amount=total_amount, 
                           shipping_address=shipping_address)