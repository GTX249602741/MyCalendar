import { CJCalendar, OptMode, Solar } from '../cjcalendar'
import { CJDateItem } from '../cjcalendar/src/main/ets/components/components/CJDateItem'
import { Const, ScheduleModel } from '../model/ScheduleModel'
import relationalStore from '@ohos.data.relationalStore'
import dbUtil from '../Util/DbUtil'


@Component
@CustomDialog
export  struct MonthDialogPage {

  controller:CustomDialogController

  @Link currentYear:number

  @Link currentMonth:number

  @Link currentDate:number

  @Link scheduleModelArray:Array<ScheduleModel>

  @Link hasCalendar:boolean

  date:Date = new Date()

  @State item:CJDateItem[] = []

  aboutToAppear(): void {

    let today: CJDateItem = new CJDateItem(this.date,null,null,Solar.fromDate(this.date))

    this.item[0] = today
  }

  async getScheduleList(){
    this.scheduleModelArray = []
    let predicates = new relationalStore.RdbPredicates("DATE");
    predicates.isNotNull("Title");
    let array = await dbUtil.queryForList(predicates, Const)
    for (let i of array) {
      if (i.StartYear <= this.currentYear && i.EndYear >= this.currentYear) {
        if (i.StartMonth == this.currentMonth && i.EndMonth == this.currentMonth) {
          if (i.StartDate <= this.currentDate && i.EndDate >= this.currentDate) {
            this.scheduleModelArray.push(i)
          }
        }
        if (i.StartMonth == this.currentMonth && i.EndMonth != this.currentMonth) {
          if (i.StartDate <= this.currentDate && i.EndDate >= this.currentDate) {
            this.scheduleModelArray.push(i)
          }
        }
        if (i.StartMonth < this.currentMonth && i.EndMonth > this.currentMonth) {
          this.scheduleModelArray.push(i)
        }
        if (i.EndMonth == this.currentMonth && i.StartMonth != this.currentMonth) {
          if (i.StartDate <= this.currentDate && i.EndDate >= this.currentDate) {
            this.scheduleModelArray.push(i)
          }
        }
      }
    }
    if(this.scheduleModelArray.length!=0){
      this.hasCalendar = true
    }
  }

  build() {
    Column(){
      CJCalendar({currentYear:$currentYear,currentMonth:$currentMonth,showLunar:true,onSelectedChanged:(item:CJDateItem[])=>{
        this.item = item
        this.currentYear = item[0].fullYear
        this.currentMonth = item[0].month+1
        this.currentDate = item[0].date

        this.getScheduleList()

      },optMode:OptMode.SINGLE})
    }

  }
}