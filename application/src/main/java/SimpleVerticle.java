import io.vertx.core.AbstractVerticle;
import io.vertx.core.DeploymentOptions;
import io.vertx.core.Vertx;

public class SimpleVerticle extends AbstractVerticle {
  public static void main(String[] args) {
    var vertx = Vertx.vertx();
    vertx.deployVerticle(SimpleVerticle.class, new DeploymentOptions());
  }

  @Override
  public void start() {
    vertx.setPeriodic(1000, id -> {
      vertx.eventBus().publish("simple-verticle-out-address", "Hello World");
    });
  }
}
