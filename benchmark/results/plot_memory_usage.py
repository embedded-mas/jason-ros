import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties

# Lê o arquivo CSV
df = pd.read_csv('random_rosnode_memlog_ros_with_perception_unified.csv', sep=';', decimal=',')

# Extrai as colunas de interesse
cpu_python = df['Memory ROS-Python (Kb)']
cpu_jason = df['Memory ROS-Jason (Kb)']
cpu_cpp = df['Memory ROS-C++ (Kb)']

# Índice das amostras
x = range(len(cpu_python))

# Define uma fonte personalizada para a legenda
#custom_font = FontProperties(family='Times New Roman', style='italic', weight='bold', size=30)



plt.figure(figsize=(12, 6))
line_python, = plt.plot(x, cpu_python, label='ROS Python', color='blue', linewidth=3)
line_jason, = plt.plot(x, cpu_jason, label='ROS Jason', color='green', linewidth=3)
line_cpp, = plt.plot(x, cpu_cpp, label='ROS C++', color='red', linewidth=3)

# Aplica a fonte personalizada à legenda
#plt.legend(prop=custom_font)


plt.xlabel('Execution time (seconds)')
plt.ylabel('Memory consumption (Kb)')
plt.title('Memory consumption Over Time')
plt.legend(fontsize=20, loc='center right')
plt.grid(True)
plt.tight_layout()

# Salva o gráfico em um arquivo PNG
plt.savefig('memory_consumption.png', dpi=300)

# Opcional: mostra o gráfico na tela
# plt.show()

