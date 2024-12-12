// Verificar si la sesión está activa
async function checkSession() {
    try {
      // Realizar la solicitud al backend
      const response = await fetch('./api/check-session', {
        method: 'GET',
        credentials: 'same-origin', // Incluir las cookies de la sesión si están disponibles
      });
  
      const result = await response.json();
      
      if(window.location.pathname.includes('index.html') && result.session.id_tipo_usuario == 1) {
        console.log(result.session.id_tipo_usuario);
        document.getElementById('usuario').insertAdjacentHTML('beforebegin', `<div class="opc" onclick="location.href = './Menu.html'">Administrar</div>`)
      }
      // Si estamos en Login.html y la sesión está activa, redirigir a index.html
      if (window.location.pathname.includes('Login.html') && result.message === 'Sesión activa') {
        window.location.href = 'index.html'; // Redirigir a la página principal si ya está logueado
      }
      // Si la sesión no está iniciada, redirigir a Login.html
      if (result.message === 'Sesión no iniciada' && !window.location.pathname.includes('Login.html')) {
        window.location.href = 'Login.html'; // Redirigir a login si la sesión no está iniciada
      }
    } catch (error) {
      console.error('Error al verificar la sesión:', error);
      // Redirigir al login si hay un error (por ejemplo, problemas de conexión)
      if (!window.location.pathname.includes('Login.html')) {
        window.location.href = 'Login.html';
      }
    }
  }
  
  // Llamar a la función para verificar la sesión al cargar la página
  checkSession();
  