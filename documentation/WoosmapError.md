# WoosmapError

Error Format of Multisearch SDK

``` swift
public enum WoosmapError: Error 
```

## Inheritance

`Error`

## Enumeration Cases

### `Error`

``` swift
case Error(message: String?, statusText: String?, status: Int?)
```

## Properties

### `errorDescription`

Status of error

``` swift
public var errorDescription: String? 
```

### `localizedDescription`

Description of error

``` swift
public var localizedDescription: String? 
```

### `status`

Error number

``` swift
public var status: Int 
```
