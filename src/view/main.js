// Código en el frontend para llenar tabla




// Código para mostrar los datos y agregar el botón de generación del PDF
function mostrar() {
  document.getElementById('salida').innerHTML = `<tr>
            <th>ID_empleado</th>
            <th>ID_tipo usuario</th>
            <th>ID_usuario</th>
            <th>nickname</th>
            <th>password</th>
            <th>Reporte</th>
        </tr>`;
  fetch('./api/tabla_usuarios')
    .then(response => {
      if (!response.ok) {
        throw new Error('Error en la solicitud');
      }
      return response.json();
    })
    .then(data => {
      const salida = document.getElementById('salida');
      for (let i = 0; i < data.length; i++) {
        const fila = salida.insertRow();
        fila.insertCell(0).innerText = data[i].id_empleado;
        fila.insertCell(1).innerText = data[i].id_tipo_usuario;
        fila.insertCell(2).innerText = data[i].id_usuario;
        fila.insertCell(3).innerText = data[i].nickname;
        fila.insertCell(4).innerText = data[i].password;

        // Crear el botón de generar reporte en cada fila
        const boton = document.createElement('button');
        boton.innerText = 'pdf';
        boton.onclick = function () {
          generarPDF1(data[i]);  // Llamamos a la función para generar el PDF
        };
        fila.insertCell(5).appendChild(boton);
      }
      console.log('Datos recibidos:', data);
    })
    .catch(error => {
      console.error('Error:', error);
    });
}


// Modificar el evento para insertar en la base de datos
document.getElementById('form_altas').addEventListener('submit', async (event) => {
  event.preventDefault();

  // Recoge los datos del formulario
  const data = {
      id_usuario: document.getElementById('id_usuario').value,
      id_empleado: document.getElementById('id_empleado').value,
      id_tipo_usuario: document.getElementById('id_tipo_usuario').value,
      nickname: document.getElementById('nickname').value,
      password: document.getElementById('password').value,
  };

  try {
      // Enviar los datos como JSON
      const response = await fetch('./api/alta_usuarios', {
          method: 'POST',
          headers: {
              'Content-Type': 'application/json',
          },
          body: JSON.stringify(data),
      });

      if (!response.ok) {
          throw new Error('Error en la solicitud');
      }

      // Respuesta de éxito
      const responseData = await response.json();
      console.log('Datos insertados:', responseData);

      // Generar y descargar el PDF con los datos insertados
      await generarPDF(data);

      alert('Datos insertados y PDF descargado con éxito.');
  } catch (error) {
      console.error('Error:', error);
  }
});

// Reutilizar la función generarPDF
async function generarPDF(data) {
  const { id_empleado, nombre, apellido_p, apellido_m, id_departamento, nickname, password, id_usuario, id_tipo_usuario } = data;

  const url = './frames/AltaEmpleado_TechSupportMX.pdf'; // Ruta del archivo PDF
  const pdfBytes = await fetch(url).then(res => res.arrayBuffer()); // Cargar el PDF en formato binario

  // Cargar el PDF en PDFLib
  const pdfDoc = await PDFLib.PDFDocument.load(pdfBytes);
  const page = pdfDoc.getPages()[0]; // Usamos la primera página del PDF

  // Definir la fuente
  const font = await pdfDoc.embedFont(PDFLib.StandardFonts.Helvetica);

  // Añadir los datos al PDF
  page.drawText(`${id_usuario}`, { x: 432, y: 376, size: 13, font: font });
  page.drawText(`${id_empleado}`, { x: 434, y: 350, size: 13, font: font, color: PDFLib.rgb(1, 0, 0) });
  page.drawText(`${id_tipo_usuario}`, { x: 434, y: 324, size: 13, font: font });
  page.drawText(`${nickname}`, { x: 434, y: 296, size: 13, font: font });
  page.drawText(`${password}`, { x: 432, y: 270, size: 13, font: font });
  
  // Guardar el PDF modificado
  const pdfBytesFinal = await pdfDoc.save();

  // Crear un enlace de descarga para el PDF generado
  const blob = new Blob([pdfBytesFinal], { type: 'application/pdf' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = `Empleado_${id_empleado}.pdf`; // Nombre del archivo generado
  link.click(); // Realiza la descarga
}




// Función para generar y descargar el PDF
async function generarPDF1(data) {
  const { id_empleado, id_tipo_usuario, id_usuario, nickname, password } = data;
  
  const url = './frames/Usuario_TechSupportMX.pdf'; // Ruta del archivo PDF
  const pdfBytes = await fetch(url).then(res => res.arrayBuffer()); // Cargar el PDF en formato binario

  // Cargar el PDF en PDFLib
  const pdfDoc = await PDFLib.PDFDocument.load(pdfBytes);
  const page = pdfDoc.getPages()[0]; // Usamos la primera página del PDF

  // Definir la fuente
  const font = await pdfDoc.embedFont(PDFLib.StandardFonts.Helvetica);

  // Añadir los datos al PDF
  page.drawText(`${id_empleado}`, { x: 445, y: 530, size: 13, font: font, color: PDFLib.rgb(1, 0, 0) });
  page.drawText(`${nickname}`, { x: 420, y: 494, size: 13, font: font });
  page.drawText(`${password}`, { x: 420, y: 459, size: 13, font: font });
  page.drawText(`${id_usuario}`, { x: 445, y: 425, size: 13, font: font });
  page.drawText(`${id_tipo_usuario}`, { x: 445, y: 395, size: 13, font: font });
 
  
  // Guardar el PDF modificado
  const pdfBytesFinal = await pdfDoc.save();

  // Crear un enlace de descarga para el PDF generado
  const blob = new Blob([pdfBytesFinal], { type: 'application/pdf' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = `Empleado_${id_empleado}.pdf`; // Nombre del archivo generado
  link.click(); // Realiza la descarga  

}
