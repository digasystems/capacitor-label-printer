# @digasystems/capacitor-label-printer

Provide a native interface to label printers

Starting from the work of:
1. [capacitor-zeroconf by trik](https://github.com/trik/capacitor-zeroconf)
2. [cordova-plugin-brother-label-printer by AbobosSoftware](https://github.com/AbobosSoftware/cordova-plugin-brother-label-printer)
3. [capacitor-brotherprint by rdlabo-team](https://github.com/rdlabo-team/capacitor-brotherprint)

## Install

```bash
npm install @digasystems/capacitor-label-printer
npx cap sync
```

## API

<docgen-index>

* [`addListener('discover', ...)`](#addlistenerdiscover)
* [`getHostname()`](#gethostname)
* [`printImage(...)`](#printimage)
* [`register(...)`](#register)
* [`unregister(...)`](#unregister)
* [`stop()`](#stop)
* [`watch(...)`](#watch)
* [`unwatch(...)`](#unwatch)
* [`close()`](#close)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### addListener('discover', ...)

```typescript
addListener(eventName: 'discover', listenerFunc: (result: LabelPrinterWatchResult) => void) => PluginListenerHandle
```

| Param              | Type                                                                                             |
| ------------------ | ------------------------------------------------------------------------------------------------ |
| **`eventName`**    | <code>'discover'</code>                                                                          |
| **`listenerFunc`** | <code>(result: <a href="#labelprinterwatchresult">LabelPrinterWatchResult</a>) =&gt; void</code> |

**Returns:** <code><a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

--------------------


### getHostname()

```typescript
getHostname() => Promise<{ hostname: string; }>
```

**Returns:** <code>Promise&lt;{ hostname: string; }&gt;</code>

--------------------


### printImage(...)

```typescript
printImage(_request: LabelPrinterPrintImageRequest) => Promise<void>
```

| Param          | Type                                                                                    |
| -------------- | --------------------------------------------------------------------------------------- |
| **`_request`** | <code><a href="#labelprinterprintimagerequest">LabelPrinterPrintImageRequest</a></code> |

--------------------


### register(...)

```typescript
register(request: LabelPrinterRegisterRequest) => Promise<void>
```

| Param         | Type                                                                                |
| ------------- | ----------------------------------------------------------------------------------- |
| **`request`** | <code><a href="#labelprinterregisterrequest">LabelPrinterRegisterRequest</a></code> |

--------------------


### unregister(...)

```typescript
unregister(request: LabelPrinterUnregisterRequest) => Promise<void>
```

| Param         | Type                                                                                    |
| ------------- | --------------------------------------------------------------------------------------- |
| **`request`** | <code><a href="#labelprinterunregisterrequest">LabelPrinterUnregisterRequest</a></code> |

--------------------


### stop()

```typescript
stop() => Promise<void>
```

--------------------


### watch(...)

```typescript
watch(request: LabelPrinterWatchRequest, callback?: LabelPrinterWatchCallback | undefined) => Promise<CallbackID>
```

| Param          | Type                                                                            |
| -------------- | ------------------------------------------------------------------------------- |
| **`request`**  | <code><a href="#labelprinterwatchrequest">LabelPrinterWatchRequest</a></code>   |
| **`callback`** | <code><a href="#labelprinterwatchcallback">LabelPrinterWatchCallback</a></code> |

**Returns:** <code>Promise&lt;string&gt;</code>

--------------------


### unwatch(...)

```typescript
unwatch(request: LabelPrinterUnwatchRequest) => Promise<void>
```

| Param         | Type                                                                          |
| ------------- | ----------------------------------------------------------------------------- |
| **`request`** | <code><a href="#labelprinterwatchrequest">LabelPrinterWatchRequest</a></code> |

--------------------


### close()

```typescript
close() => Promise<void>
```

--------------------


### Interfaces


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |


#### LabelPrinterService

| Prop                | Type                                    |
| ------------------- | --------------------------------------- |
| **`domain`**        | <code>string</code>                     |
| **`type`**          | <code>string</code>                     |
| **`name`**          | <code>string</code>                     |
| **`port`**          | <code>number</code>                     |
| **`hostname`**      | <code>string</code>                     |
| **`ipv4Addresses`** | <code>string[]</code>                   |
| **`ipv6Addresses`** | <code>string[]</code>                   |
| **`txtRecord`**     | <code>{ [key: string]: string; }</code> |


#### LabelPrinterPrintImageRequest

| Prop          | Type                |
| ------------- | ------------------- |
| **`ip`**      | <code>string</code> |
| **`image`**   | <code>string</code> |
| **`printer`** | <code>string</code> |
| **`label`**   | <code>string</code> |


#### LabelPrinterRegisterRequest

| Prop        | Type                                    |
| ----------- | --------------------------------------- |
| **`port`**  | <code>number</code>                     |
| **`props`** | <code>{ [key: string]: string; }</code> |


#### LabelPrinterUnregisterRequest

| Prop       | Type                |
| ---------- | ------------------- |
| **`name`** | <code>string</code> |


#### LabelPrinterWatchRequest

| Prop         | Type                |
| ------------ | ------------------- |
| **`type`**   | <code>string</code> |
| **`domain`** | <code>string</code> |


### Type Aliases


#### LabelPrinterWatchResult

<code>{ action: <a href="#labelprinterwatchaction">LabelPrinterWatchAction</a>; service: <a href="#labelprinterservice">LabelPrinterService</a>; }</code>


#### LabelPrinterWatchAction

<code>'added' | 'removed' | 'resolved'</code>


#### LabelPrinterWatchCallback

<code>(event: <a href="#labelprinterwatchresult">LabelPrinterWatchResult</a>): void</code>


#### CallbackID

<code>string</code>


#### LabelPrinterUnwatchRequest

<code><a href="#labelprinterwatchrequest">LabelPrinterWatchRequest</a></code>

</docgen-api>
