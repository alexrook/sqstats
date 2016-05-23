package sqstats.rs;

import java.net.URI;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

/**
 * @author moroz
 */
@Provider
public class NotFoundExceptionMapper implements ExceptionMapper<NotFoundException> {

    @Override
    public Response toResponse(NotFoundException exception) {
        /*
        Здесь обрабатываются ошибки NotFoundException для сервисов.
        Перенаправление на несуществующий ресурс ../404 (выше контекста jax-rs приложения)
        повзволяет задействовать настройки error-page=404 in web.xml
        тестированно для Wildfly 9.0.2
         */
        return Response.seeOther(URI.create("../404")).build();
    }

}
