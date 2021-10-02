from lib.config import WebDriver
import lf2gym
from time import sleep

env = lf2gym.make(
    startServer=True,
    wrap='skip4',
    driverType=lf2gym.WebDriver.Chrome,
    headless=True
)

env.reset()
env.close()
