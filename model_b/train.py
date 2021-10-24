# Adapted from https://www.pyimagesearch.com/2019/02/11/fashion-mnist-with-keras-and-deep-learning

# import the necessary packages
from minivgg import MiniVGGNet
import argparse
import tensorflow as tf
import mlflow

parser = argparse.ArgumentParser()
parser.add_argument("--epochs", type=int, required=False, default=10)
args = parser.parse_args()

# Download the data
fashion_mnist = tf.keras.datasets.fashion_mnist

(train_images, train_labels), (test_images,
                               test_labels) = fashion_mnist.load_data()

train_images = train_images.reshape(train_images.shape[0], 28, 28, 1)
test_images = test_images.reshape(test_images.shape[0], 28, 28, 1)

model = MiniVGGNet.build(width=28, height=28, depth=1, classes=10)

model.compile(optimizer='adam',
              loss=tf.keras.losses.SparseCategoricalCrossentropy(
                  from_logits=False),
              metrics=['accuracy'])

with mlflow.start_run():
    mlflow.tensorflow.autolog()
    model.fit(x=train_images, y=train_labels,
              epochs=args.epochs)

    test_loss, test_acc = model.evaluate(test_images,  test_labels, verbose=2)
    mlflow.log_param(key="test_acc", value=test_acc)

    print('\nTest accuracy:', test_acc)

    model_output = "vgg_model.h5"
    model.save(model_output)
    mlflow.log_artifact(local_path=model_output)
