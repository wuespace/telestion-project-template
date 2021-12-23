import de.wuespace.telestion.api.verticle.GenericConfiguration;
import de.wuespace.telestion.api.verticle.TelestionVerticle;
import de.wuespace.telestion.api.verticle.trait.WithEventBus;
import io.vertx.core.DeploymentOptions;
import io.vertx.core.Vertx;

public class SimpleVerticle extends TelestionVerticle<GenericConfiguration> implements WithEventBus {
	public static void main(String[] args) {
		var vertx = Vertx.vertx();
		vertx.deployVerticle(SimpleVerticle.class, new DeploymentOptions());
	}

	@Override
	public void onStart() {
		vertx.setPeriodic(1000, id -> {
			logger.debug("Publish new message on event bus");
			publish("simple-verticle-out-address", "Hello World");
		});
	}
}
