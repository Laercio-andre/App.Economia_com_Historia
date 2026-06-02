// src/main/java/com/economiangola/domain/entity/PerfilProfessor.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "perfis_professor")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PerfilProfessor extends BaseEntity {

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false, unique = true)
    private Usuario usuario;

    @Column(name = "especialidade", length = 255)
    private String especialidade;

    @Column(name = "biografia", length = 2000)
    private String biografia;

    @Column(name = "verificado", nullable = false)
    @Builder.Default
    private Boolean verificado = false;
}
