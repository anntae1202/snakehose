# snakehose
keras 신경망을 활용한 뱀과 고무호스 분류

1. 작업 툴
웹스크롤링 : Selenium, Beautifulsoup, pandas
신경망 학습 : keras, sklearn
웹페이지 구현 : Rstudio, Rshiny

2. 작품소개
CNN 신경망을 활용한 이미지 분류모델입니다.
이미지를 분류할 주제를 뱀과 고무 호스로 선정한뒤, 두가지 데이터를 각각 약 1500장 이상씩 웹스크롤링하였습니다.
그 뒤 수집한 이미지 데이터를 학습이 잘 되도록 resize 한뒤,
keras 신경망을 층을 구성하여 정확도 98% 의 모델을 생성했습니다. 

https://marionet.shinyapps.io/SnakeVsHose/

현재 shiny 설정 오류로 뱀사진을 넣으면 고무호스가, 고무호스를 넣으면 뱀이 출력되면 정상 작동입니다....
