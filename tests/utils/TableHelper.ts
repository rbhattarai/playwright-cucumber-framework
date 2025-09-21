export class TableHelper {
  static convertToDict(table: any[]): Record<string, string>[] {
    return table.map(row => Object.fromEntries(Object.entries(row)));
  }
}
