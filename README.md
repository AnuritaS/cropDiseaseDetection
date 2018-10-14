# Crop Disease Detection Using  Vision and Core ML

Preprocess photos using the Vision framework and classify them with a Core ML model.

## Overview

With the [Core ML](https://developer.apple.com/documentation/coreml) framework, you can use a trained machine learning model to classify input data. The [Vision](https://developer.apple.com/documentation/vision) framework works with Core ML to apply classification models to images, and to preprocess those images to make machine learning tasks easier and more reliable.

This sample app uses the open source MobileNet model, one of several [available classification models](https://developer.apple.com/machine-learning), to identify an image using 1000 classification categories as seen in the example screenshots below.



## Getting Started

This sample code project runs on iOS 11, on Xcode 10 and above.

## Preview the Sample App

To see this sample app in action, build and run the project, then use the buttons in the sample app's toolbar to take a picture or choose an image from your photo library. The sample app then uses Vision to apply the Core ML model to the chosen image, and shows the resulting classification labels along with numbers indicating the confidence level of each classification. It displays the top two classifications in order of the confidence score the model assigns to each.

## Set Up Vision with a Core ML Model

Core ML automatically generates a Swift class that provides easy access to your ML model; in this sample, Core ML automatically generates the `MobileNet` class from the `MobileNet` model.  To set up a Vision request using the model, create an instance of that class and use its `model` property  to create a [`VNCoreMLRequest`](https://developer.apple.com/documentation/vision/vncoremlrequest) object. Use the request object's completion handler to specify a method to receive results from the model after you run the request.

``` swift
let model = try VNCoreMLModel(for: MobileNet().model)

let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
    self?.processClassifications(for: request, error: error)
})
request.imageCropAndScaleOption = .centerCrop
return request
```
[View in Source](x-source-tag://MLModelSetup)

An ML model processes input images in a fixed aspect ratio, but input images may have arbitrary aspect ratios, so Vision must scale or crop the image to fit. For best results, set the request's [`imageCropAndScaleOption`](https://developer.apple.com/documentation/vision/vncoremlrequest/2890144-imagecropandscaleoption) property to match the image layout the model was trained with. For the [available classification models](https://developer.apple.com/machine-learning), the [`centerCrop`](https://developer.apple.com/documentation/vision/vnimagecropandscaleoption/centercrop) option is appropriate unless noted otherwise.

[View in Source](x-source-tag://ProcessClassifications)
