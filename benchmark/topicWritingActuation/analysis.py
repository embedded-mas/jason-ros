import csv
from datetime import datetime

def calcular_diferenca_media_tempo(caminho_csv):
    with open(caminho_csv, newline='') as arquivo:
        leitor = csv.DictReader(arquivo)
        tempos = [datetime.fromisoformat(linha['Time']) for linha in leitor]

    if len(tempos) < 2:
        print("É necessário pelo menos dois registros para calcular a diferença.")
        return None

    diferencas = [
        (tempos[i+1] - tempos[i]).total_seconds()
        for i in range(len(tempos) - 1)
    ]

    media = sum(diferencas) / len(diferencas)

    print(str(sum(diferencas))+" / " + str(len(diferencas)))
    return media

# Exemplo de uso
if __name__ == "__main__":
    caminho_do_arquivo = 'value_log_jason.csv'  # Altere para o nome do seu arquivo
    media = calcular_diferenca_media_tempo(caminho_do_arquivo)
    if media is not None:
        print(f'Diferença média de tempo: {media:.10f} segundos')
