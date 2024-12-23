from flask import Flask, render_template, request, redirect, url_for, flash,session
from flask_mysqldb import MySQL
from werkzeug.security import generate_password_hash, check_password_hash
from app.config import Config
from app.database import Database
import MySQLdb
from app.views import main_views  # 确保导入views.py中的Blueprint

app = Flask(__name__)
app.config.from_object(Config)
db = Database(app)

mysql = MySQL(app)

@app.route('/')
def index():
    return render_template('index.html')  # 渲染主页模板

# 登录后的主页路由
@app.route('/dashboard')
def dashboard():
    if 'username' not in session:  # 如果用户未登录，重定向到登录页面
        return redirect(url_for('login'))
    
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM books")  # 假设你有一个名为 books 的表
    books = cursor.fetchall()
    cursor.close()
    return render_template('dashboard.html', books=books)  # 登录后的主页

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        name = request.form.get('username')
        pwd = request.form.get('password')
        
        if not name or not pwd:
            flash("用户名和密码不能为空", "error")
            return redirect(url_for('login'))
        
        cursor = mysql.connection.cursor(cursorclass=MySQLdb.cursors.DictCursor)  # 使用字典游标
        cursor.execute("SELECT * FROM customers WHERE CustomerID = %s", (name,))
        user = cursor.fetchone()
        
        if user and check_password_hash(user['Password'], pwd):
            session['username'] = user['CustomerID']  # 存储用户名到 session
            return redirect(url_for('dashboard'))  # 登录成功，重定向到主页
        else:
            flash("用户名或密码错误", "error")
    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    error_message = None
    if request.method == 'POST':
        name = request.form.get('username')
        pwd = request.form.get('password')
        
        if not name or not pwd:
            error_message = "用户名和密码不能为空"
        else:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM customers WHERE CustomerID = %s", (name,))
            user = cur.fetchone()
            cur.close()
            
            if user:
                error_message = "用户名已存在"
            else:
                hashed_pwd = generate_password_hash(pwd)
                cur = mysql.connection.cursor()
                cur.execute("INSERT INTO customers (CustomerID, Password, Name, Address) VALUES (%s, %s, %s, %s)",
                            (name, hashed_pwd, name, ''))
                mysql.connection.commit()
                cur.close()
                return redirect(url_for('login'))  # 注册成功后，重定向到登录页面

    return render_template('register.html', error=error_message)

# 退出登录路由
@app.route('/logout')
def logout():
    session.clear()  # 清除整个session
    return redirect(url_for('index'))  # 重定向到未登录用户的主页

app.register_blueprint(main_views, url_prefix='/')

if __name__ == '__main__':
    app.run(debug=True)