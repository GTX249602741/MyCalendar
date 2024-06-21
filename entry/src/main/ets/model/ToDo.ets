import { ScheduleModel } from './ScheduleModel'
@Observed
export class ToDo{
  public desc:string

  public flag:boolean

  public scheduleModelArray:ScheduleModel[]
}