# Machine Learning README
- 머신러닝 모델링 담당 : 이용환
- 사용언어 : Python 3.9
- 사용 라이브러리 : Pandas(데이터 전처리), Pyplot(데이터 및 결과 시각화), Scikit-learn(머신러닝 알고리즘), Numpy(수학 및 데이터 전처리)

# ML Specification
- Model : KMeans(n_clusters=1)
- Num of Clusters : 1 (All dataset is in a cluster)
- Why? : Because we need only 'What is exactly proper sensor data?'. So K-mean is enough simple and easy to find it.

# DataSet
- 현재 랜덤으로 생성하여 확인함.
- 습도 범위(X축) : 0 ~ 1023
- 조도 범위(Y축) : 180 ~ 500

# Process
- 1차 모델링 실험 성공(0624)
- 1차 모델링 데이터 셋 Pandas표로 정리(0624)
- 1차 모델링 범위 조정 실험 성공(0624)
- 1차 모델링 예상 실제 데이터 실험 성공(0624)
- 2차 모델링 실험(습도 센서 값 딥러닝 지도학습) 성공(0718)
- 3차 모델링 실험(조도, 습도 센서 값 딥러닝 지도학습) 성공(0718)
- 모델 과정 함수화 및 정리 (0718)