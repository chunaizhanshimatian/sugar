document.getElementById('loginForm').onsubmit = function(event) {
    event.preventDefault();
    const customerID = document.getElementById('customerID').value;
    const password = document.getElementById('password').value;
    
    fetch('/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ CustomerID: customerID, Password: password }),
    })
    .then(response => response.json())
    .then(data => {
        if (data.message === 'Login successful') {
            alert('登录成功');
            // 可以在这里添加登录成功后的逻辑，例如跳转到另一个页面
        } else {
            alert('登录失败');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('登录请求失败');
    });
};