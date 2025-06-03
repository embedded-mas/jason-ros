import pandas as pd
import matplotlib.pyplot as plt

# Lê o arquivo CSV
df = pd.read_csv('random_rosnode_memlog_ros_with_perception_unified.csv', sep=';', decimal=',')

# Extrai as colunas de interesse
cpu_python = df['CPU percent-ros python']
cpu_jason = df['CPU percent-ros Jason']
cpu_cpp = df['CPU percent-ros C++']

# Índice das amostras
x = range(len(cpu_python))

# Gera o gráfico
plt.figure(figsize=(12, 6))
plt.plot(x, cpu_python, label='Python', color='blue',  linewidth=3)
plt.plot(x, cpu_jason, label='Jason', color='green',  linewidth=3)
plt.plot(x, cpu_cpp, label='C++', color='red',  linewidth=3)

plt.xlabel('Execution time (seconds)')
plt.ylabel('CPU Usage (%)')
plt.title('CPU Usage Over Time')
plt.legend(fontsize=20, loc='best')
plt.grid(True)
plt.tight_layout()

# Salva o gráfico em um arquivo PNG
plt.savefig('cpu_usage.png', dpi=300)

# Opcional: mostra o gráfico na tela
# plt.show()

