// Código en el frontend
function mostrar() {
  document.getElementById('salida').innerHTML = `<tr>
            <th>ID_empleado</th>
            <th>ID_tipo usuario</th>
            <th>ID_usuario</th>
            <th>nickname</th>
            <th>password</th>
        </tr>`;
  fetch('http://localhost:3000/api/tabla_usuarios')
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la solicitud');
      }
      return response.json();
    })
    .then(data => {
      const salida = document.getElementById('salida')
      for(let i = 0; i < data.length; i++) {
      salida.insertAdjacentHTML('beforeend', `<tr>
        <td>${data[i].id_empleado}</td>
        <td>${data[i].id_tipo_usuario}</td>
        <td>${data[i].id_usuario}</td>
        <td>${data[i].nickname}</td>
        <td>${data[i].password}</td></tr>`);
      }
      console.log('Datos recibidos:', data);
      
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }


document.getElementById('form_altas').addEventListener('submit', (event) => {
  event.preventDefault();

  // Recoge los datos del formulario
  const data = {
    id_usuario: document.getElementById('id_usuario').value,
    id_empleado: document.getElementById('id_empleado').value,
    id_tipo_usuario: document.getElementById('id_tipo_usuario').value,
    nickname: document.getElementById('nickname').value,
    password: document.getElementById('password').value,
  };

  // Envía los datos como JSON
  fetch('http://localhost:3000/api/alta_usuarios', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(data)
  })
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la solicitud');
      }
      return response.json();
    })
    .then(data => {
      console.log(data);
      alert("Usuario guardado correctamente");
    })
    .catch(error => {
      console.error('Error:', error);
    });
});
