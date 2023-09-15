export interface LabelPrinterPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
