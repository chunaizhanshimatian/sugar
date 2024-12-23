from flask import Blueprint, render_template, request, jsonify,flash,redirect,url_for
from werkzeug.security import check_password_hash
from .database import Database
import pymysql

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
def customer_info():
    customer_id = request.args.get('customer_id')
    if not customer_id:
        return jsonify({"message": "Missing customer_id"}), 400

    db = Database()
    conn = db.connect()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        cursor.execute("SELECT * FROM customers WHERE CustomerID = %s", (customer_id,))
        customer = cursor.fetchone()
        if customer:
            cursor.execute("SELECT * FROM viewcustomerorders WHERE CustomerID = %s", (customer_id,))
            orders = cursor.fetchall()
            return jsonify({"customer": customer, "orders": orders})
        else:
            return jsonify({"message": "Customer not found"}), 404
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
        isbn = request.form.get('isbn')
        title = request.form.get('title')
        authors = request.form.get('authors').split(',')  # 假设作者字段以逗号分隔
        publisher_id = request.form.get('publisher_id')
        price = request.form.get('price')
        keywords = request.form.get('keywords').split(',')  # 假设关键字字段以逗号分隔
        summary = request.form.get('summary')
        cover_image = request.form.get('cover_image')
        stock_quantity = request.form.get('stock_quantity')
        suppliers = request.form.get('supplier').split(',')  # 假设供应商字段以逗号分隔
        
        # 数据验证
        if not isbn or not title or not price:
            flash('所有字段都是必填的。')
            return redirect(url_for('main.manage_books'))
        
        try:
            # 插入书籍信息到数据库
            cursor.execute("INSERT INTO books (ISBN, Title, PublisherID, Price, Keywords, Summary, CoverImage, StockQuantity) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", (isbn, title, publisher_id, price, ','.join(keywords), summary, cover_image, stock_quantity))
            conn.commit()
            
            # 处理作者关系
            for author in authors:
                cursor.execute("INSERT INTO authors (AuthorName) VALUES (%s)", (author,))
                author_id = cursor.lastrowid
                cursor.execute("INSERT INTO book_authors (BookISBN, AuthorID) VALUES (%s, %s)", (isbn, author_id))
            
            # 处理供应商关系
            for supplier in suppliers:
                cursor.execute("INSERT INTO book_suppliers (BookISBN, SupplierID) VALUES (%s, %s)", (isbn, supplier))
            
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
