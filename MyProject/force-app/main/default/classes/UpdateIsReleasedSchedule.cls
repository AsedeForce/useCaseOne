public class UpdateIsReleasedSchedule implements Schedulable {
    public void execute(SchedulableContext context) {
        UpdateIsReleaseBatch updateIsReleaseBatch = new UpdateIsReleaseBatch();
        database.executeBatch(updateIsReleaseBatch);
    }
}