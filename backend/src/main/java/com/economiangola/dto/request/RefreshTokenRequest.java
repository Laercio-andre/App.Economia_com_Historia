// src/main/java/com/economiangola/dto/request/RefreshTokenRequest.java
package com.economiangola.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RefreshTokenRequest {

    @NotBlank(message = "O refresh token é obrigatório")
    private String refreshToken;
}
