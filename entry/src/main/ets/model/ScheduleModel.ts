
import { ColumnInfo, ColumnType } from '../Util/ColumnInfo'

export const CreateTableSQL:string = '' +
'CREATE TABLE IF NOT EXISTS DATE (' +
'ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
'StartYear INTEGER NOT NULL,' +
'EndYear INTEGER NOT NULL,' +
'StartMonth INTEGER NOT NULL,' +
'EndMonth INTEGER NOT NULL,' +
'StartDate INTEGER NOT NULL,' +
'EndDate INTEGER NOT NULL,' +
'WholeDay INTEGER NOT NULL,' +
'HourStart INTEGER,' +
'MinuteStart INTEGER,' +
'HourEnd INTEGER,' +
'MinuteEnd INTEGER,' +
'Title TEXT NOT NULL,' +
'IsFinish INTEGER NOT NULL,' +
'Content TEXT)'

export  const Const:ColumnInfo[] = [
  {name:'id',columnName:'id',type:ColumnType.INTGER},
  {name:'StartYear',columnName:'StartYear',type:ColumnType.INTGER},
  {name:'EndYear',columnName:'EndYear',type:ColumnType.INTGER},
  {name:'StartMonth',columnName:'StartMonth',type:ColumnType.INTGER},
  {name:'EndMonth',columnName:'EndMonth',type:ColumnType.INTGER},
  {name:'StartDate',columnName:'StartDate',type:ColumnType.INTGER},
  {name:'EndDate',columnName:'EndDate',type:ColumnType.INTGER},
  {name:'HourStart',columnName:'HourStart',type:ColumnType.INTGER},
  {name:'HourEnd',columnName:'HourEnd',type:ColumnType.INTGER},
  {name:'MinuteStart',columnName:'MinuteStart',type:ColumnType.INTGER},
  {name:'MinuteEnd',columnName:'MinuteEnd',type:ColumnType.INTGER},
  {name:'WholeDay',columnName:'WholeDay',type:ColumnType.INTGER},
  {name:'IsFinish',columnName:'IsFinish',type:ColumnType.INTGER},
  {name:'Title',columnName:'Title',type:ColumnType.STRING},
  {name:'content',columnName:'Content',type:ColumnType.STRING}
]

export class ScheduleModel{

  id:number

  StartYear:number

  EndYear:number

  StartMonth:number

  EndMonth:number

  StartDate:number

  EndDate:number

  HourStart:number

  MinuteStart:number

  HourEnd:number

  MinuteEnd:number

  IsFinish:number

  WholeDay:Number

  Title:string

  content:string

}