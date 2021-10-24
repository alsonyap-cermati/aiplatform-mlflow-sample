# Adapted from: https://www.tensorflow.org/tutorials/keras/classification

import os
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

model = tf.keras.Sequential([
    tf.keras.layers.Flatten(input_shape=(28, 28)),
    tf.keras.layers.Dense(128, activation='relu'),
    tf.keras.layers.Dense(10)
])

model.compile(optimizer='adam',
              loss=tf.keras.losses.SparseCategoricalCrossentropy(
                  from_logits=True),
              metrics=['accuracy'])

with mlflow.start_run():
    mlflow.tensorflow.autolog()
    model.fit(train_images, train_labels, epochs=args.epochs)

    test_loss, test_acc = model.evaluate(test_images,  test_labels, verbose=2)
    mlflow.log_param(key="test_acc", value=test_acc)

    print('\nTest accuracy:', test_acc)

    model_output = "simple_model.h5"
    model.save(model_output)
    mlflow.log_artifact(local_path=model_output)
