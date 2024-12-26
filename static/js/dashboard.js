// scripts.js
function searchCustomer() {
    var customerId = document.getElementById('customer_id').value;
    var password = document.getElementById('password').value; // 获取密码输入值

    // 简单的前端验证，确保ID和密码都已输入
    if (!customerId || !password) {
        alert('客户ID和密码不能为空');
        return;
    }

    fetch(`/customer/info?customer_id=${customerId}&password=${encodeURIComponent(password)}`, {
        method: 'GET' // 使用GET方法
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        const customerInfoDiv = document.getElementById('customer-info1');
        customerInfoDiv.innerHTML = ''; // 清空之前的内容

        if (data.message) {
            customerInfoDiv.innerHTML = `<p class="error">${data.message}</p>`; // 展示错误信息
        } else {
            let customerHTML = `
                <div class="customer-details">
                    <h2>客户详情</h2>
                    <p><strong>姓名:</strong> ${data.customer.Name}</p>
                    <p><strong>地址:</strong> ${data.customer.Address}</p>
                    <p><strong>账户余额:</strong> ${data.customer.AccountBalance}</p>
                    <p><strong>信用等级:</strong> ${data.customer.CreditLevel}</p>
                </div>
            `;
            let ordersHTML = `<div class="orders"><h2>订单</h2>`;
            if (data.orders.length > 0) {
                ordersHTML += `<ul>`;
                data.orders.forEach(order => {
                    ordersHTML += `
                        <li>
                            <p><strong>订单ID:</strong> ${order.OrderID}</p>
                            <p><strong>日期:</strong> ${order.OrderDate}</p>
                            <p><strong>地址:</strong> ${order.Address}</p>
                            <p><strong>总金额:</strong> ${order.TotalAmount}</p>
                            <p><strong>状态:</strong> ${order.Status}</p>
                        </li>
                    `;
                });
                ordersHTML += `</ul>`;
            } else {
                ordersHTML += `<p>该客户没有订单。</p>`;
            }
            ordersHTML += `</div>`;
            customerInfoDiv.innerHTML = customerHTML + ordersHTML;
        }
    })
    .catch(error => {
        const customerInfoDiv = document.getElementById('customer-info1');
        customerInfoDiv.innerHTML = `<p class="error">请求失败: ${error.message}</p>`; // 展示请求失败的错误信息
        console.error('Error:', error);
    });
}
function searchBooks() {
    var isbn = document.getElementById('isbn').value;
    var title = document.getElementById('title').value;
    var publisher = document.getElementById('publisher').value;
    var keywords = document.getElementById('keywords').value;
    var author = document.getElementById('author').value;
    fetch(`/books?isbn=${isbn}&title=${title}&publisher=${publisher}&keywords=${keywords}&author=${author}`)
        .then(response => response.json())
        .then(data => {
            var tableBody = document.getElementById('books-table').getElementsByTagName('tbody')[0];
            tableBody.innerHTML = ''; // 清空现有数据
            data.forEach(book => {
                var row = tableBody.insertRow();
                row.insertCell(0).textContent = book.ISBN;
                row.insertCell(1).textContent = book.Title;
                row.insertCell(2).textContent = book.PublisherID; // 假设PublisherID是外键
                row.insertCell(3).textContent = book.Price;
                row.insertCell(4).textContent = book.Keywords;
                row.insertCell(5).textContent = book.StockQuantity;
            });
        })
        .catch(error => console.error('Error:', error));
}