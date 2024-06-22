import font from '@ohos.font';
import image from '@ohos.multimedia.image';
import { MyOneDayPage } from './MyOneDayPage';
import { YearPage } from './YearPage'
import router from '@ohos.router'
import relationalStore from '@ohos.data.relationalStore'
import dbUtil from '../Util/DbUtil'
import { Const, ScheduleModel } from '../model/ScheduleModel'
import thermal from '@ohos.thermal';
import { Todo } from './Todo'

@Entry
@Component
struct Index {

  date:Date = new Date()

  @State currentYear:number = AppStorage.Get('currentYear')

  @State currentMonth:number = this.date.getUTCMonth()+1

  @State currentDate:number = this.date.getDate()

  private controller:TabsController = new TabsController()

  @State img:string = ''

  @State currentIndex:number = 0

  @State hasCalendar:boolean = false

  @State scheduleModelArray:Array<ScheduleModel> = []

  @State ArrayFinish:ScheduleModel[] = []

  @State ArrayOutDated:ScheduleModel[] = []

  async getScheduleFinishList(){
    this.ArrayFinish = []
    let predicates = new relationalStore.RdbPredicates("DATE");
    predicates.equalTo('IsFinish',1);
    let array = await dbUtil.queryForList(predicates, Const)
    for(let i of array){
      this.ArrayFinish.push(i)
    }

  }

  async getScheduleOutDatedList(){
    this.ArrayOutDated = []
    let predicates = new relationalStore.RdbPredicates("DATE");
    predicates.equalTo('IsFinish',0)
    let array = await dbUtil.queryForList(predicates, Const)
    for(let i of array){
      if (this.currentYear>i.EndYear) {
        this.ArrayOutDated.push(i)
      }
      if(this.currentYear = i.EndYear){
        if (this.currentMonth > i.EndMonth) {
          this.ArrayOutDated.push(i)
        }
        if (this.currentMonth = i.EndMonth) {
          if (this.currentDate > i.EndDate) {
            this.ArrayOutDated.push(i)
          }
        }
      }

    }
  }

  async getScheduleList(){
    this.scheduleModelArray = []
    let predicates = new relationalStore.RdbPredicates("DATE");
    predicates.isNotNull("Title");
    predicates.equalTo('IsFinish',0)
    let array = await dbUtil.queryForList(predicates, Const)
    for (let i of array) {
      if (i.StartYear <= this.currentYear && i.EndYear >= this.currentYear) {
        if (i.StartMonth == this.currentMonth && i.EndMonth == this.currentMonth) {
          if (i.StartDate <= this.currentDate && i.EndDate >= this.currentDate) {
            this.scheduleModelArray.push(i)
          }
        }
        if (i.StartMonth == this.currentMonth && i.EndMonth != this.currentMonth) {
          if (i.StartDate <= this.currentDate ) {
            this.scheduleModelArray.push(i)
          }
        }
        if (i.StartMonth < this.currentMonth && i.EndMonth > this.currentMonth) {
          this.scheduleModelArray.push(i)
        }
        if (i.EndMonth == this.currentMonth && i.StartMonth != this.currentMonth) {
          if (i.EndDate >= this.currentDate) {
            this.scheduleModelArray.push(i)
          }
        }
      }
    }
    if(this.scheduleModelArray.length!=0){
      this.hasCalendar = true
    }
  }

  @Builder TabBuilder(index:number,name:string,image:ResourceStr,imagefill:ResourceStr){
    Column(){
      Image(this.currentIndex === index? imagefill:image)
        .height(30)
        .margin({top:5})
      Text(name)
        .fontSize(10)
        .margin({top:5})
    }.width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
  }

  aboutToAppear(){
    this.getScheduleList()
    this.getScheduleFinishList()
    this.getScheduleOutDatedList()
  }

  onPageShow(){

    console.log('test2','onPageShow')
   /** if(router.getParams()!=null){
      let param:any = router.getParams()
      this.currentYear = param.currentYear
      console.log('test2',param.currentYear.toString())

    }
**/
    let YearParam :number = AppStorage.Get('currentYear')
    let MonthParam:number = AppStorage.Get('currentMonth')
    console.log('test2',YearParam.toString())
    this.currentYear = YearParam
    this.currentMonth = MonthParam

    this.getScheduleFinishList()
    console.log('test4',1)
    this.getScheduleOutDatedList()
    console.log('test4',2)
    this.getScheduleList()
    console.log('test5',this.scheduleModelArray.length.toString())
  }

  build() {
    Column(){
      Tabs({controller:this.controller,barPosition:BarPosition.End,index:this.currentIndex}){
        TabContent(){
          YearPage({currentYear:$currentYear})
        }.tabBar(this.TabBuilder(0,'日程',$r('app.media.ic_public_calendar'),$r('app.media.ic_public_calendar_filled')))

        TabContent(){
          MyOneDayPage({hasCalendar:$hasCalendar,scheduleModelArray:$scheduleModelArray})

        }.tabBar(this.TabBuilder(1,'我的一天',$r('app.media.rili'),$r('app.media.rili_fill')))

        TabContent(){
          Todo({scheduleModelArray:$scheduleModelArray,ArrayFinish:$ArrayFinish,ArrayOutDated:$ArrayOutDated,hasCalendar:this.hasCalendar})

        }.tabBar(this.TabBuilder(2,'待办',$r('app.media.ic_public_todo'),$r('app.media.ic_public_todo_filled')))
      }.onChange((index:number)=>{
        this.currentIndex = index
      } )
    }.height('100%')
    .width('100%')

  }
}