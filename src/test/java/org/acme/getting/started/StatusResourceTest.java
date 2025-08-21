package org.acme.getting.started;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;

@QuarkusTest
public class StatusResourceTest {

    @Test
    public void testStatusEndpoint() {
        given()
          .when().get("/status")
          .then()
          .statusCode(200)
          .body("message", is("Application is running"));
    }
}