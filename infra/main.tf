name: Deploy Application

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Check out the repository
        uses: actions/checkout@v2

      - name: Set up SSH
        env:
          SSH_KEY: ${{ secrets.EC2_SSH_KEY }}
        run: |
          # Crear el directorio .ssh si no existe
          mkdir -p ~/.ssh
          # Guardar la clave SSH en un archivo
          echo "$SSH_KEY" > ~/.ssh/id_rsa
          # Asegurarse de que la clave tenga los permisos correctos
          chmod 600 ~/.ssh/id_rsa
          # Agregar el host a known_hosts para evitar advertencias en la conexión
          ssh-keyscan -H "44.221.46.187" >> ~/.ssh/known_hosts

      - name: Deploy to EC2
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          EC2_HOST: "ubuntu@44.221.46.187"
        run: |
          ssh $EC2_HOST << 'EOF'
            # Navegar al directorio de la aplicación o clonar el repositorio si no existe
            if [ ! -d "inventario" ]; then
              git clone https://github.com/carlosflores21/inventario.git inventario
            fi
            cd inventario

            # Actualizar el código desde el repositorio
            git pull origin main

            # Instalar Node.js y npm si no están instalados
            if ! command -v node &> /dev/null; then
              curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
              sudo apt-get install -y nodejs
            fi

            # Instalar dependencias de la aplicación
            npm install

            # Instalar pm2 si no está instalado para mantener la aplicación corriendo
            if ! command -v pm2 &> /dev/null; then
              sudo npm install -g pm2
            fi

            # Iniciar o reiniciar la aplicación usando pm2 con el nombre "inventario"
            pm2 start index.js --name "inventario" || pm2 restart "inventario"
            
            # Guardar la configuración de pm2 para reinicios futuros
            pm2 save
          EOF
