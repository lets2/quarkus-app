package org.acme.getting.started;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;
import java.net.URI;

@Path("/")
public class RootRedirectResource {

    @GET
    public Response redirectToSwagger(){
        return Response
            .seeOther(URI.create("/q/swagger-ui"))
            .build();
    }
    
}

