# IDView
Custom Beautiful UIView For Handling IDs in iOS

<p align="center">
    <img src="https://github.com/O-labib/IDView/blob/main/demo-gif.gif" width="240" height="500" />
</p>


# Setup
Set the placeholder images for the front and back faces.

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
     
        idView.frontPlaceHolderImage = ...
        idView.backPlaceHolderImage = ...
        
    ...
```     

# Change Images
- To set the image for the current face..
```swift
    idView.set(image: UIImage(), flip: true)
```
- Or you can just flip the view without changing the images..
```swift
    idView.flip()
```

# Delegate
Set the view delegate to get feedback when image changes through..
```swift
    func idView(_ idView: IDView, wasTappedOn face: IDView.Face)
```

# Properties
- get the current face..
```swift
    idView.face
```
- get the image for particular face..
```swift
    idView.image(for: .back)
    idView.image(for: .front)
```
