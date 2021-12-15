package ##GROUP_ID##;

import io.vertx.core.AbstractVerticle;

public class SimpleVerticle extends AbstractVerticle {
  @Override
  public void start() {
    vertx.setPeriodic(1000, id -> {
      vertx.eventBus().publish("simple-verticle-out-address", "Hello World");
    });
  }
}
