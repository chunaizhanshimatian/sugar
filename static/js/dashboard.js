// scripts.js
function searchCustomer() {
    var customerId = document.getElementById('customer_id').value;
    fetch(`/customer/info?customer_id=${customerId}`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('customer-info').innerHTML = JSON.stringify(data, null, 2);
        })
        .catch(error => console.error('Error:', error));
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