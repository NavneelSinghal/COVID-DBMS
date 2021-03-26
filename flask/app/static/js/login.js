const elem = document.querySelector.bind(document);
const username_field = elem('input[name=username]');
const password_field = elem('input[name=password]');
const submit = elem('button');

submit.addEventListener('click', () => {
  if (username_field.value !== 'admin') {
	window.alert('User not authorized');
	return;
  } 
  if (password_field.value === '') {
	window.alert('Enter a password!!');
	return;
  }
  window.location.replace('/admin');
});
