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

* [`printImage(...)`](#printimage)
* [`watch(...)`](#watch)
* [`unwatch(...)`](#unwatch)
* [`close()`](#close)
* [`addListener('serviceDiscovered', ...)`](#addlistenerservicediscovered)
* [`removeAllListeners()`](#removealllisteners)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### printImage(...)

```typescript
printImage(_request: LabelPrinterPrintImageRequest) => Promise<void>
```

| Param          | Type                                                                                    |
| -------------- | --------------------------------------------------------------------------------------- |
| **`_request`** | <code><a href="#labelprinterprintimagerequest">LabelPrinterPrintImageRequest</a></code> |

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


### addListener('serviceDiscovered', ...)

```typescript
addListener(eventName: 'serviceDiscovered', listenerFunc: (orientation: LabelPrinterWatchResult) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                                                                                                  |
| ------------------ | ----------------------------------------------------------------------------------------------------- |
| **`eventName`**    | <code>'serviceDiscovered'</code>                                                                      |
| **`listenerFunc`** | <code>(orientation: <a href="#labelprinterwatchresult">LabelPrinterWatchResult</a>) =&gt; void</code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

--------------------


### removeAllListeners()

```typescript
removeAllListeners() => Promise<void>
```

--------------------


### Interfaces


#### LabelPrinterPrintImageRequest

| Prop          | Type                |
| ------------- | ------------------- |
| **`ip`**      | <code>string</code> |
| **`image`**   | <code>string</code> |
| **`printer`** | <code>string</code> |
| **`label`**   | <code>string</code> |


#### LabelPrinterWatchRequest

| Prop         | Type                |
| ------------ | ------------------- |
| **`type`**   | <code>string</code> |
| **`domain`** | <code>string</code> |


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


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |


### Type Aliases


#### LabelPrinterWatchCallback

<code>(event: <a href="#labelprinterwatchresult">LabelPrinterWatchResult</a>): void</code>


#### LabelPrinterWatchResult

<code>{ action: <a href="#labelprinterwatchaction">LabelPrinterWatchAction</a>; service: <a href="#labelprinterservice">LabelPrinterService</a>; }</code>


#### LabelPrinterWatchAction

<code>'added' | 'removed' | 'resolved'</code>


#### CallbackID

<code>string</code>


#### LabelPrinterUnwatchRequest

<code><a href="#labelprinterwatchrequest">LabelPrinterWatchRequest</a></code>

</docgen-api>
