// Código en el frontend
fetch('http://localhost:3000/api/tabla_usuarios')
  .then(response => {
    if (!response.ok) {
      throw new Error('Error en la solicitud');
    }
    return response.json();
  })
  .then(data => {
    console.log('Datos recibidos:', data);
    // Aquí puedes manipular los datos, por ejemplo, renderizarlos en el DOM
  })
  .catch(error => {
    console.error('Error:', error);
  });
