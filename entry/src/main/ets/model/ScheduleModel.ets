
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
  {name:'id',columnName:'id',type:ColumnType.INTEGER},
  {name:'StartYear',columnName:'StartYear',type:ColumnType.INTEGER},
  {name:'EndYear',columnName:'EndYear',type:ColumnType.INTEGER},
  {name:'StartMonth',columnName:'StartMonth',type:ColumnType.INTEGER},
  {name:'EndMonth',columnName:'EndMonth',type:ColumnType.INTEGER},
  {name:'StartDate',columnName:'StartDate',type:ColumnType.INTEGER},
  {name:'EndDate',columnName:'EndDate',type:ColumnType.INTEGER},
  {name:'HourStart',columnName:'HourStart',type:ColumnType.INTEGER},
  {name:'HourEnd',columnName:'HourEnd',type:ColumnType.INTEGER},
  {name:'MinuteStart',columnName:'MinuteStart',type:ColumnType.INTEGER},
  {name:'MinuteEnd',columnName:'MinuteEnd',type:ColumnType.INTEGER},
  {name:'WholeDay',columnName:'WholeDay',type:ColumnType.INTEGER},
  {name:'IsFinish',columnName:'IsFinish',type:ColumnType.INTEGER},
  {name:'Title',columnName:'Title',type:ColumnType.STRING},
  {name:'content',columnName:'Content',type:ColumnType.STRING}
]
@Observed
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

  WholeDay:number

  Title:string

  content:string

}