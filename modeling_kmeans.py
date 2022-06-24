import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

X_water = np.random.randint(0, 1024, 10) # 습도 센서 값(0 ~ 1023) 10개
Y_light = np.random.randint(180, 501, 10) # 조도 센서 값(180 ~ 500) 10개
X_water_like = np.random.randint(600, 700, 90) # 습도 센서 값(600 ~ 700) 90개
Y_light_like = np.random.randint(200, 250, 90) # 조도 센서 값(200 ~ 250) 90개

X = np.array([])
X = np.append(X, X_water)
X = np.append(X, X_water_like)

Y = np.array([])
Y = np.append(Y, Y_light)
Y = np.append(Y, Y_light_like)

plt.scatter(X, Y, s=100, c='b') # 그래프에 표시(2차원, x축은 습도 y축은 조도)
plt.show() # 그래프 띄우기 1차(데이터 시각화)

Dataset = np.zeros((100, 2)) # 2차원 배열 원소 100개
for i in range(100):
    Dataset[i] = [X[i], Y[i]] # [[습도, 조도], ... ]

# 데이터 매칭 확인
table = pd.DataFrame(Dataset) # Pandas 표 생성
table.columns = ['습도','조도'] # 칼럼 변경
print(table) # 데이터 매칭 표로 확인

from sklearn.cluster import KMeans # KMeans Clustering 불러오기
Kmean = KMeans(n_clusters=1) # cluster 1개로 KMeans
Kmean.fit(Dataset) # model fitting

plt.scatter(X, Y, s =100, c='b') # 모델 이용된 데이터 포인트들 그래프에 표시
plt.scatter(Kmean.cluster_centers_[0][0],Kmean.cluster_centers_[0][1], s=200, c='g', marker='s') # 센서 값 중 적정 값 중앙에 표시(Means)
plt.show() # 그래프 띄우기 2차(데이터 시각화)

print("적정 센서 데이터 : ", Kmean.cluster_centers_[0][0], Kmean.cluster_centers_[0][1]) # 센서 중앙값(적정 데이터) 확인