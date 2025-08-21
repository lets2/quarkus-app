package org.acme.getting.started;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/status-novo")
public class StatusResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public StatusResponse getStatus() {
        return new StatusResponse("Application is running");
    }

    public static class StatusResponse {
        private String message;

        public StatusResponse() {
        }

        public StatusResponse(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}
