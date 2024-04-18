import random
import threading
import time

import rclpy
from rclpy.node import Node
from std_msgs.msg import Int32

PROB = 99
DECREMENT = 5
SLEEP_TIME = 2

energy_turtle1 = 100
energy_turtle2 = 100

class EnergyNode(Node):
    def __init__(self):
        super().__init__('energy_node')
        self.energy_publisher_1 = self.create_publisher(Int32, '/turtle1/energy', 10)
        self.energy_publisher_2 = self.create_publisher(Int32, '/turtle2/energy', 10)
        self.subscription_1 = self.create_subscription(
            Int32,
            '/turtle1/energy',
            self.callback1,
            10
        )
        self.subscription_2 = self.create_subscription(
            Int32,
            '/turtle2/energy',
            self.callback2,
            10
        )
        self.subscription_1  # to prevent unused variable warning
        self.subscription_2  # to prevent unused variable warning

    def callback1(self, data):
        self.get_logger().info(f'Received: {data.data}')
        global energy_turtle1
        energy_turtle1 = data.data

    def callback2(self, data):
        self.get_logger().info(f'Received: {data.data}')
        global energy_turtle2
        energy_turtle2 = data.data

    def publish_random_energy(self):
        global energy_turtle1
        global energy_turtle2

        while True:
            probability = random.randint(0, 100)
            if probability < PROB:
                random_number = random.randint(0, DECREMENT)
                energy_turtle1 -= random_number
                msg = Int32()
                msg.data = energy_turtle1
                self.energy_publisher_1.publish(msg)
                self.get_logger().info(f'Published to /turtle1/energy: {msg.data}')

            probability = random.randint(0, 100)
            if probability < PROB:
                random_number = random.randint(0, DECREMENT)
                energy_turtle2 -= random_number
                msg = Int32()
                msg.data = energy_turtle2
                self.energy_publisher_2.publish(msg)
                self.get_logger().info(f'Published to /turtle2/energy: {msg.data}')

            time.sleep(SLEEP_TIME)

def main():
    rclpy.init()
    node = EnergyNode()

    # Start a thread to publish random energy
    publish_thread = threading.Thread(target=node.publish_random_energy)
    publish_thread.daemon = True
    publish_thread.start()

    # Spin the node to keep it running and processing callbacks
    rclpy.spin(node)

    # Clean up
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()

