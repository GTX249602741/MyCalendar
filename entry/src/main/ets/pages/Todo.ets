import { Const, ScheduleModel } from '../model/ScheduleModel'
import { ToDo } from '../model/ToDo'
import relationalStore from '@ohos.data.relationalStore'
import dbUtil from '../Util/DbUtil'
import observer from '@ohos.telephony.observer'

@Component
export struct Todo {

  date:Date = new Date()

  @State currentYear:number = this.date.getFullYear()

  @State currentMonth:number = this.date.getMonth()+1

  @State currentDate:number = this.date.getDate()

  @State rotateAngle:number = 0

  @State rotateAngle2:number = 0

  @State rotateAngle3:number = 0

  @State flag:boolean = true

  @State flag2:boolean = true

  @State flag3:boolean = true

  @Prop hasCalendar:boolean

  @Link scheduleModelArray:ScheduleModel[]

  @Link ArrayFinish:ScheduleModel[]

  @Link ArrayOutDated:ScheduleModel[]

  scroller:Scroller = new Scroller()

  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})}



 // @State toDoArray:ToDo[] = [{desc:'待办',flag:this.flag,scheduleModelArray:this.scheduleModelArray},{desc:'完成',flag:this.flag2,scheduleModelArray:this.ArrayFinish},{desc:'过期',flag:this.flag3,scheduleModelArray:this.ArrayOutDated}]


 /** async getScheduleList(){
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
     // this.hasCalendar = true
    }
    console.log('test4',1)
  }

  async getScheduleFinishList(){
    this.ArrayFinish = []
    let predicates = new relationalStore.RdbPredicates("DATE");
    predicates.equalTo('IsFinish',1);
    let array = await dbUtil.queryForList(predicates, Const)
    for(let i of array){
    this.ArrayFinish.push(i)
    }
    console.log('test4',5)
  }
  async getScheduleOutDatedList(){
    this.ArrayOutDated = []
    let predicates = new relationalStore.RdbPredicates("DATE");
    predicates.equalTo('IsFinish',0)
    let array = await dbUtil.queryForList(predicates, Const)
    for(let i of array){
      if (this.currentYear>=i.EndYear&&this.currentMonth>=i.EndMonth&&this.currentDate>=i.EndDate) {
        if(i.HourEnd<=new Date().getHours()){
          if(i.MinuteEnd<new Date().getMinutes()){
            this.ArrayOutDated.push(i)
          }
        }
        }

      }
    console.log('test4',3)
    }
**/
  aboutToAppear(){

  }



  @Builder CustomBuilder(item:ScheduleModel){
    Row(){
      Image($r('app.media.ic_public_ok_filled'))
        .size({height:20,width:20})
        .margin({right:10,left:10})
        .onClick(()=>{
          let predicates = new relationalStore.RdbPredicates("DATE");
          predicates.equalTo('Title',item.Title);
          dbUtil.delete(predicates)
        })
      Image($r('app.media.ic_public_delete'))
        .size({height:20,width:20})
        .margin({right:10})
    }

  }

  build(){
    Scroll(this.scroller){
      Column(){
        Row(){
          Text('待办')
            .fontSize(15)
            .margin({left:10})
          Blank()
          Image($r('app.media.ic_public_arrow_up_0'))
            .size({height:15,width:15})
            .rotate({angle:this.rotateAngle})
            .onClick(()=>{
              this.rotateAngle = this.rotateAngle+180
              this.flag = !this.flag
            })
            .animation({
              duration: 500,
              curve: Curve.Friction,
              delay: 0,
              iterations: 1, // 设置-1表示动画无限循环
              playMode: PlayMode.Normal
            })
        }
        .justifyContent(FlexAlign.Start)
        .width('95%')
        .height('7%')

        List(){
          ForEach(this.scheduleModelArray,(item:ScheduleModel)=>{
            ListItem(){
              Row() {
                Divider()
                  .vertical(true)
                  .color('#0091FF')
                  .height('70%')
                  .strokeWidth(4)
                  .lineCap(LineCapStyle.Round)
                  .margin({ left: 10, right: 10 })
                Text(item.Title)
                  .fontSize(25)

              }
              .borderRadius(15)
              .builder()
              .justifyContent(FlexAlign.Start)
              .height('7%')
              .width('95%')
            }
            .swipeAction({end:this.CustomBuilder()})
          })
        }
        .visibility(this.flag == true?Visibility.Visible:Visibility.None)
        Row(){
          Text('已完成')
            .fontSize(15)
            .margin({left:10})
          Blank()
          Image($r('app.media.ic_public_arrow_up_0'))
            .size({height:15,width:15})
            .rotate({angle:this.rotateAngle2})
            .onClick(()=>{
              this.rotateAngle2 = this.rotateAngle2+180
            })
            .animation({
              duration: 500,
              curve: Curve.Friction,
              delay: 0,
              iterations: 1, // 设置-1表示动画无限循环
              playMode: PlayMode.Normal
            })
        }
        .justifyContent(FlexAlign.Start)
        .width('95%')
        .height('7%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
   }
}
 /** build() {
    List({space:10}){
      ForEach(this.toDoArray,(item:ToDo)=>{
        ListItemGroup({ header:this.itemHead(item.desc,item.flag)}){
          ForEach(item.scheduleModelArray, (item:ScheduleModel) => {
            ListItem() {
              scheduleArray({item:item})
            }
            .swipeAction({end:this.CustomBuilder()})

          })
        }
        .visibility(item.flag == true?Visibility.Visible:Visibility.None)
        .width('100%')
        .height('100%')
      }
      )
    }
    .chainAnimation(true)
    .alignListItem(ListItemAlign.Center)
    .width('100%')
    .height('100%')

  }
}


@Component
struct scheduleArray{

  @ObjectLink item:ScheduleModel

build() {

  Row() {
    Divider()
      .vertical(true)
      .color('#0091FF')
      .height('70%')
      .strokeWidth(4)
      .lineCap(LineCapStyle.Round)
      .margin({ left: 10, right: 10 })
    Text(this.item.Title)
      .fontSize(25)

  }
  .borderRadius(15)
  .builder()
  .justifyContent(FlexAlign.Start)
  .height('7%')
  .width('95%')
}

  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})}

}
  **/