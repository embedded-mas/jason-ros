#!/bin/bash

# Configurações
DOCKER_USER=maiquelb
DOCKER_REPO=embedded-mas-ros

# Solicita a versão ao usuário
read -p "Digite a versão da imagem (exemplo: 1.0): " VERSION

IMAGE_NAME="$DOCKER_USER/$DOCKER_REPO"

# Build da imagem com a versão informada e também com tag latest
echo "🔨 Construindo a imagem Docker..."
docker build -t $IMAGE_NAME:$VERSION -t $IMAGE_NAME:latest .

# Login no Docker Hub
echo "🔑 Fazendo login no Docker Hub..."
docker login

# Faz push das imagens
echo "📤 Enviando as imagens para o Docker Hub..."
docker push $IMAGE_NAME:$VERSION
docker push $IMAGE_NAME:latest

echo "✅ Push concluído com sucesso!"

