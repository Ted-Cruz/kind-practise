# app.py
from fastapi import FastAPI
import time

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello World"}

@app.get("/cpu")
def cpu_load():
    # 模擬 CPU 壓力
    t_end = time.time() + 2  # 模擬 2 秒 CPU 密集運算
    while time.time() < t_end:
        _ = 12345 * 67890
    return {"message": "CPU intensive task completed"}
