import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

X= -1*np.random.randint(0, 1024, (100,2)) # 습도 센서 값
X_light = np.random.randint(180, 500, (50,2)) # 조도 센서 값
X[50:100, :] = X_light # 절반은 습도, 나머지 절반은 조도
plt.scatter(X[:, 0], X[:, 1], s=50, c='b') # 그래프에 표시
plt.show() # 그래프 띄우기 1차(데이터 시각화)

from sklearn.cluster import KMeans # KMeans Clustering 불러오기
Kmean = KMeans(n_clusters=2) # cluster 2개로 KMeans
Kmean.fit(X) # model fitting

df2 = pd.DataFrame(Kmean.labels_) # label panadas 표로 구성
print(df2) # label 확인

print(Kmean.cluster_centers_) # 센터 배열 확인
print(Kmean.cluster_centers_[0]) # 센터 배열 중 0번째 값 확인(조도센서)
plt.scatter(X[ : , 0], X[ : , 1], s =50, c='b') # 모델 이용된 데이터 포인트들 그래프에 표시
plt.scatter(Kmean.cluster_centers_[0][0], Kmean.cluster_centers_[0][1], s=200, c='g', marker='s') # 조도센서 값 중 적정 조도 값 중앙에 표시(Means)
plt.scatter(Kmean.cluster_centers_[1][0], Kmean.cluster_centers_[1][1], s=200, c='r', marker='s') # 습도센서 값 중 적정 습도 값 중앙에 표시(Means)
plt.show() # 그래프 띄우기 2차(데이터 시각화)

print("light_center : ",Kmean.cluster_centers_[0][0], Kmean.cluster_centers_[0][1]) # 조도 센서 중앙값(적정 데이터) 확인
print("water_center : ",-1*Kmean.cluster_centers_[1][0], -1*Kmean.cluster_centers_[1][1]) # 습도 센서 중앙값(적정 데이터) 확인
print(Kmean.labels_) # 군집 확인