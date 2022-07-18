import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

import torch
import torch.nn as nn
import torch.optim as optim

def DL_Singmulwon(X1, Y1, num, str_what_data):
    loss_fn = nn.MSELoss() # 이 비용 함수는 소프트맥스 함수를 포함하고 있음.
    model = nn.Sequential(
        nn.Linear(900,500), # input_layer = 3, hidden_layer1 = 8
        nn.ReLU(),
        nn.Linear(500,250), # input_layer = 3, hidden_layer1 = 8
        nn.ReLU(),
        nn.Linear(250,1), # input_layer = 3, hidden_layer1 = 8
    )
    optimizer = optim.Adam(model.parameters(), lr=0.01)
    losses = []
    sensors = []
    def train(epoch,num):
        model.train()  # 신경망을 학습 모드로 전환
        optimizer.zero_grad()  # 경사를 0으로 초기화
        outputs = model(X1)  # 데이터를 입력하고 출력을 계산
        #print("outputs : ", outputs)
        loss = loss_fn(outputs, Y1)  # 출력과 훈련 데이터 정답 간의 오차를 계산
        loss.backward()  # 오차를 역전파 계산
        optimizer.step()  # 역전파 계산한 값으로 가중치를 수정
        if(epoch % (num/10) == 0):
            print("epoch{}：완료 {}".format(epoch,loss))
            losses.append(loss.item())
            sensors.append(torch.median(outputs.data, 0).values.item())
    def test():
        model.eval()  # 신경망을 추론 모드로 전환
        # 데이터로더에서 미니배치를 하나씩 꺼내 추론을 수행
        with torch.no_grad():  # 추론 과정에는 미분이 필요없음
            outputs = model(X1)  # 데이터를 입력하고 출력을 계산
            # 추론 계산
            sen, predicted = torch.median(outputs.data, 0)  # 확률이 가장 높은 레이블이 무엇인지 계산
            print(str_what_data, sen.item())
        return sen.item()
    for epoch in range(num):
        train(epoch,num)

    plt.plot(losses)
    plt.show()
    plt.plot(sensors)
    plt.show()
    return test()


X_water_0 = np.random.randint(0, 1023, 1000) # 습도 센서 값(0 ~ 1023) 1000개
Y_water_like = np.random.randint(640, 660, 10) # 습도 센서 값(600 ~ 700) 90개

X_water_train = np.empty((0,1),int)
Y_water_train = np.empty((0,1),int)

for i in range(0, 900):
    X_water_train = np.append(X_water_train, np.array(X_water_0[i]))

for i in range(0, 1):
    Y_water_train = np.append(Y_water_train, np.array(Y_water_like[i]))

X1_water = torch.tensor(X_water_train, dtype=torch.float32)
Y1_water = torch.tensor(Y_water_train, dtype=torch.float32)



X_light_0 = np.random.randint(180, 200, 1000) # 조도 센서 값(180 ~ 500) 1000개
Y_light_like = np.random.randint(220, 230, 1000) # 조도 센서 값(200 ~ 250) 90개

X_light_train = np.empty((0,1),int)
Y_light_train = np.empty((0,1),int)

for i in range(0, 900):
    X_light_train = np.append(X_light_train, np.array(X_light_0[i]))

for i in range(0, 1):
    Y_light_train = np.append(Y_light_train, np.array(Y_light_like[i]))

X1_light = torch.tensor(X_light_train, dtype=torch.float32)
Y1_light = torch.tensor(Y_light_train, dtype=torch.float32)

ans_arr = np.array([])
ans_arr = np.append(ans_arr, np.array([DL_Singmulwon(X1_water, Y1_water, 1000, "적정 습도 데이터 값 : ")]))
ans_arr = np.append(ans_arr, np.array([DL_Singmulwon(X1_light, Y1_light, 1000, "적정 조도 데이터 값 : ")]))
print(ans_arr) # 0번 인덱스가 적정 습도, 1번 인덱스가 적정 조도