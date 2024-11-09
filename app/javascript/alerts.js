function showLoginAlert() {
  const alertBox = document.createElement('div');
  alertBox.className = 'alert-box';
  alertBox.innerText = 'You need to sign in';

  if (document.body) {
    document.body.appendChild(alertBox);
    document.querySelectorAll('form textarea').forEach(input => {
      input.value = '';
    });

    setTimeout(() => {
      alertBox.remove();
    }, 3000);
  }
}
window.showLoginAlert = showLoginAlert;
showLoginAlert();
