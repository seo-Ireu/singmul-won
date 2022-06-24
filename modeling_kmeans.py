import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

X_water = np.random.randint(0, 1024, 100) # 습도 센서 값(0 ~ 1023) 100개
Y_light = np.random.randint(180, 501, 100) # 조도 센서 값(180 ~ 500) 100개

plt.scatter(X_water, Y_light, s=100, c='b') # 그래프에 표시(2차원, x축은 습도 y축은 조도)
plt.show() # 그래프 띄우기 1차(데이터 시각화)

X = np.zeros((100, 2)) # 2차원 배열 원소 100개
for i in range(100):
    X[i] = [X_water[i],Y_light[i]] # [[습도, 조도], ... ]

# 데이터 매칭 확인
table = pd.DataFrame(X) # Pandas 표 생성
table.columns = ['습도','조도'] # 칼럼 변경
print(table) # 데이터 매칭 표로 확인

from sklearn.cluster import KMeans # KMeans Clustering 불러오기
Kmean = KMeans(n_clusters=1) # cluster 1개로 KMeans
Kmean.fit(X) # model fitting

plt.scatter(X_water, Y_light, s =100, c='b') # 모델 이용된 데이터 포인트들 그래프에 표시
plt.scatter(Kmean.cluster_centers_[0][0],Kmean.cluster_centers_[0][1], s=200, c='g', marker='s') # 센서 값 중 적정 값 중앙에 표시(Means)
plt.show() # 그래프 띄우기 2차(데이터 시각화)

print("적정 센서 데이터 : ", Kmean.cluster_centers_[0][0], Kmean.cluster_centers_[0][1]) # 센서 중앙값(적정 데이터) 확인