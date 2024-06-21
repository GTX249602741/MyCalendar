export interface ColumnInfo{
  name: string
  columnName: string
  type: ColumnType
}

export enum ColumnType{

  INTGER,
  STRING
}