import sys
from PyQt6.QtWidgets import QApplication, QDialog, QMessageBox
# Importamos Ui_Dialog que se generó en principal.py
from principal import Ui_Dialog


class MiAplicacion(QDialog, Ui_Dialog):
    def __init__(self):
        super().__init__()
        # Se dibuja la ventana
        self.setupUi(self)

        # Conectamos las acciones de los botones Aceptar / Cancelar
        self.buttonBox.accepted.connect(self.guardar_datos)
        self.buttonBox.rejected.connect(self.reject)

    def guardar_datos(self):
        # Capturar el texto ingresado por el usuario
        nombre = self.txtNombre.text().strip()
        apellido = self.txtApellido.text().strip()
        matricula = self.txtMatricula.text().strip()
        telefono = self.txtTelefono.text().strip()

        # Validar que los campos no queden vacíos
        if not nombre or not apellido or not matricula or not telefono:
            QMessageBox.warning(self, "Advertencia", "Por favor completa todos los campos.")
            return

        # Escribir y guardar en el archivo registros.txt
        with open("registros.txt", "a", encoding="utf-8") as archivo:
            archivo.write(f"Nombre: {nombre} | Apellido: {apellido} | Matrícula: {matricula} | Teléfono: {telefono}\n")

        QMessageBox.information(self, "Éxito", "Los datos se guardaron correctamente.")

        # Limpiar los campos para volver a escribir
        self.txtNombre.clear()
        self.txtApellido.clear()
        self.txtMatricula.clear()
        self.txtTelefono.clear()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    ventana = MiAplicacion()
    ventana.show()
    sys.exit(app.exec())