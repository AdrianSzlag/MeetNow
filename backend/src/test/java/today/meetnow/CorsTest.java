package today.meetnow;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;

import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import java.util.HashMap;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.options;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(classes = MeetNowApplication.class)
@AutoConfigureMockMvc
public class CorsTest {

    private ObjectMapper objectMapper = new ObjectMapper();

    String jsonContent = objectMapper.writeValueAsString(new HashMap<String, String>() {{
        put("dateOfBirth", "2023-05-12");
        put("email", "a23eee2");
        put("firstName", "string");
        put("image", "string");
        put("lastName", "string");
        put("password", "123123");
        put("phone_nr", "123123123");
        put("username", "ase4esadrea323a1e2");
    }});
    @Autowired
    private MockMvc mockMvc;

    public CorsTest() throws JsonProcessingException {
    }

    @Test
    @Transactional
    public void corsHeaders() throws Exception {
        this.mockMvc.perform(options("/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(jsonContent)
                .header("Access-Control-Request-Method", "POST")
                .header("Origin", "http://localhost:5273"))
                .andExpect(status().isOk());
    }
}