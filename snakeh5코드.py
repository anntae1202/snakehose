import  cv2
import  os 
import  numpy  as np

path = "d:\\data\\snake\\train"

file_list = os.listdir(path)


for k in file_list:
    img = cv2.imread(path + '\\' + k)
    width, height = img.shape[:2]
    resize_img = cv2.resize(img, (32 , 32), interpolation=cv2.INTER_CUBIC)
    cv2.imwrite('d:\\data\\snake\\train_resize\\' + k, resize_img)  




import  cv2
import  os 
import  numpy  as np

path = "d:\\data\\snake\\test"

file_list = os.listdir(path)


for k in file_list:
    img = cv2.imread(path + '\\' + k)
    width, height = img.shape[:2]
    resize_img = cv2.resize(img, (32 , 32), interpolation=cv2.INTER_CUBIC)
    cv2.imwrite('d:\\data\\snake\\test_resize\\' + k, resize_img)  




path = "d:\\data\\snake\\train_label.csv"
file = open(path,'w')
for i in range(0,1354):
    file.write(str(1) +'\n')
for i in range(0,1354):
    file.write(str(0)+'\n')
file.close() # 0이 호스 1이 뱀

#%%
path = "d:\\data\\snake\\test_label.csv"
file = open(path,'w')
for i in range(0,71):
    file.write(str(1) +'\n')
for i in range(0,71):
    file.write(str(0)+'\n')
file.close() # 0이 호스 1이 뱀




import loader3

train_image='d:\\data\\snake\\train_resize\\'

train_label = "d:\\data\\snake\\train_label.csv"

test_image='d:\\data\\snake\\test_resize\\'

test_label = "d:\\data\\snake\\test_label.csv"

print(loader3.image_load(train_image).shape)
print(loader3.image_load(test_image).shape)
print(loader3.label_load(train_label).shape)
print(loader3.label_load(test_label).shape)




-----------------------

케라스스터디3


#%%
#from keras.datasets import cifar10
from keras.models import Sequential, save_model
from keras.layers import Dense, Dropout, Activation, Flatten
from keras.layers import Conv2D, MaxPooling2D
import numpy as np
from keras.utils import np_utils
from keras.layers.normalization import BatchNormalization
import loader3

batch_size = 28
num_classes = 2
epochs = 30
 
train_image = 'D:\\data\\snake\\train_resize\\'
test_image = 'D:\\data\\snake\\test_resize\\'
train_label = 'D:\\data\\snake\\train_label.csv'
test_label = 'D:\\data\\snake\\test_label.csv'

x_train = loader3.image_load(train_image)
y_train = loader3.label_load(train_label)
x_test = loader3.image_load(test_image)
y_test = loader3.label_load(test_label)      


print ( loader3.image_load(train_image).shape )
print ( loader3.image_load(test_image).shape )
print ( loader3.label_load(train_label).shape)
print ( loader3.label_load(test_label).shape )


#(x_train, y_train), (x_test, y_test) = cifar10.load_data()
# One hot Encoding
#y_train = np_utils.to_categorical(y_train)
#y_test = np_utils.to_categorical(y_test)


model = Sequential()
model.add(Conv2D(32, (3, 3), padding='same', input_shape=x_train.shape[1:]))
model.add(BatchNormalization())
model.add(Activation('relu'))
model.add(Conv2D(32, (3, 3)))
model.add(BatchNormalization())
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))


model.add(Conv2D(64, (3, 3), padding='same'))
model.add(BatchNormalization())
model.add(Activation('relu'))
model.add(Conv2D(64, (3, 3)))
model.add(BatchNormalization())
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))

model.add(Flatten()) # 완전연결계층
model.add(Dense(512))
model.add(BatchNormalization())
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(num_classes))
model.add(Activation('softmax'))
 
model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
 
x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255
 
hist = model.fit(x_train, y_train, validation_data=(x_test, y_test), nb_epoch=epochs, batch_size=batch_size, verbose=2)
 
scores = model.evaluate(x_test, y_test, verbose=0)
print("CNN Error: %.2f%%" % (100-scores[1]*100))
 
save_model(model, "D:\\data\\snake\\snake.h5")

