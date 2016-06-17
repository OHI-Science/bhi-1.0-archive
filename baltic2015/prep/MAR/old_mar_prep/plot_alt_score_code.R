temp_score
mar_status

#plot final year scores
windows()
par(mfrow=c(1,1))
plot(status~rgn_id, data= temp_score, pch=0, cex=2,
     ylim=c(0,110), col="blue")
par(new=TRUE)
plot(status~rgn_id, data= mar_status, pch=2, cex=2,
     ylim=c(0,110), col="black")
legend("topleft", legend=c("temporal moving window ref", "95th percentile spatial ref"),
       col=c("blue","black"),pch=c(0,2),bty='n')

windows()
par(mfrow=c(2,1), mar=c(3,2,2,1))
plot(status~rgn_id, data= temp_score, pch=0, cex=2,
     ylim=c(0,110), col="blue")
par(new=FALSE)
plot(status~rgn_id, data= mar_status, pch=2, cex=2,
     ylim=c(0,110), col="black")
legend("topright", legend=c("temporal moving window ref", "95th percentile spatial ref"),
       col=c("blue","black"),pch=c(0,2),bty='n')



## plot all five status years
temp_status
mar_status_score

windows()
ggplot(temp_status)+geom_point(aes(year,score))+
  facet_wrap(~rgn_id)

windows()
ggplot(filter(mar_status_score, year%in%status_years))+geom_point(aes(year,status))+
  facet_wrap(~rgn_id)
